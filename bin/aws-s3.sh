#!/usr/bin/env bash
set -euo pipefail

mkdir -p ./content/adapters/storage/s3
cp -r ./node_modules/ghost-storage-adapter-s3/. ./content/adapters/storage/s3/

# Ghost 6.65 exports StorageBase by name; the legacy S3 adapter expects the
# constructor itself. Adapt the copied entrypoint to either export format.
node <<'NODE'
const fs = require('fs');
const path = './content/adapters/storage/s3/index.js';
const source = fs.readFileSync(path, 'utf8');
const original = "require('ghost-storage-base')";
if (!source.includes(original)) {
  throw new Error('S3 adapter entrypoint changed; review StorageBase compatibility');
}
fs.writeFileSync(path, source.replace(original,
  "(require('ghost-storage-base').StorageBase || require('ghost-storage-base'))"));

// Load and instantiate the actual copied adapter during the build, without
// making an S3 request, so dependency/export errors fail before deployment.
const S3 = require('./content/adapters/storage/s3');
const adapter = new S3({bucket: 'build-validation', region: 'us-east-1'});
for (const method of adapter.requiredFns) {
  if (typeof adapter[method] !== 'function') {
    throw new Error(`S3 adapter is missing ${method}`);
  }
}
NODE

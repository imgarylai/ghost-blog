# Ghost Blog on Heroku

Deploy [Ghost](https://ghost.org/) (v5) blogging platform on Heroku with just one click. This repository provides a streamlined way to get your Ghost blog running on Heroku with minimal configuration.

## Quick Deploy

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Features

- Latest Ghost v5 support
- Automatic database setup (JawsDB MySQL)
- Built-in email service (Mailgun)
- Optional AWS S3 storage support
- Heroku Stack 24
- Automatic post-deployment configuration

## Prerequisites

- A Heroku account
- (Optional) AWS S3 account for file storage

## Heroku Configuration

When deploying through the deploy button, you'll be prompted to configure the following:

### Required Configuration

| Variable                | Description                              | Default                           |
| ----------------------- | ---------------------------------------- | --------------------------------- |
| `APP_PUBLIC_URL`        | Complete URL of your app including https | https://YOURAPPNAME.herokuapp.com |
| `NPM_CONFIG_PRODUCTION` | Required to fix npm dev dependencies     | false                             |

### Optional S3 Storage Configuration

| Variable               | Description                           | Required |
| ---------------------- | ------------------------------------- | -------- |
| `S3_ACCESS_KEY_ID`     | AWS Access Key ID for S3 file storage | No       |
| `S3_ACCESS_SECRET_KEY` | AWS Access Secret Key                 | No       |
| `S3_BUCKET_NAME`       | Name of your S3 bucket                | No       |
| `S3_BUCKET_REGION`     | Region of your S3 bucket              | No       |
| `S3_ASSET_HOST_URL`    | Custom CDN asset host URL             | No       |

### Automatic Add-ons

The following add-ons are automatically provisioned:

- **JawsDB**: MySQL database for Ghost
- **Mailgun**: Email service for newsletters and notifications

## Manual Installation

1. Clone this repository:

```bash
git clone https://github.com/imgarylai/ghost-blog.git
cd ghost-blog
```

2. Create a new Heroku app:

```bash
heroku create your-app-name
```

3. Add required add-ons:

```bash
heroku addons:create jawsdb
heroku addons:create mailgun
```

4. Configure environment variables:

```bash
heroku config:set APP_PUBLIC_URL=https://your-app-name.herokuapp.com
heroku config:set NPM_CONFIG_PRODUCTION=false
```

5. (Optional) Configure S3 storage:

```bash
heroku config:set S3_ACCESS_KEY_ID=your_access_key
heroku config:set S3_ACCESS_SECRET_KEY=your_secret_key
heroku config:set S3_BUCKET_NAME=your_bucket_name
heroku config:set S3_BUCKET_REGION=your_bucket_region
```

6. Deploy to Heroku:

```bash
git push heroku main
```

## Post-Installation

1. After deployment, visit `https://your-app-name.herokuapp.com/ghost` to set up your admin account
2. Complete the initial Ghost setup process
3. Start writing and publishing!

## File Storage Options

By default, the app will use Cloudinary for file storage. If you want to use AWS S3:

1. Create an S3 bucket in your AWS account
2. Configure CORS settings for your bucket
3. Set up the S3 environment variables listed above
4. Files will automatically be stored in your S3 bucket

## Troubleshooting

- If images aren't uploading, verify your S3 configuration
- For database issues, check JawsDB connection settings
- Visit the [Ghost Forum](https://forum.ghost.org/) for additional support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Credits

- [Ghost](https://ghost.org/) - The professional publishing platform
- [Heroku](https://heroku.com/) - Cloud platform service

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Homeland is an open-source discussion forum/community website system based on Ruby China. It's a Ruby on Rails 8.0.3 application with PostgreSQL, Redis, and Shakapacker for frontend asset compilation. The application supports multi-tenancy, SSO authentication, file uploads (local/cloud), and runs background jobs via Sidekiq.

## Common Development Commands

### Initial Setup
```bash
# Install dependencies (if not using Docker)
bundle install
pnpm install  # or yarn install

# Setup database and environment
docker-compose up  # Start PostgreSQL and Redis
bin/rails db:setup  # or db:create && db:migrate && db:seed

# Start development servers
bin/dev  # Starts both Rails server and Shakapacker dev server
# OR run separately:
bin/rails s          # Rails server on port 3000
pnpm start           # Shakapacker dev server on port 3035
```

### Running Tests
```bash
bundle exec rails test              # Run full test suite
bundle exec rails test test/models  # Run model tests only
bundle exec rails test test/integration  # Run integration tests
```

### Code Quality & Linting
```bash
bundle exec standardrb --fix        # Auto-fix Ruby code style
bundle exec rubocop                 # Check Ruby code style
npx prettier --write app/javascript/**/*.{js,ts}  # Format JavaScript/TypeScript
```

### Asset Management
```bash
bundle exec rails assets:precompile   # Precompile assets for production
pnpm start                           # Start Shakapacker dev server with hot reload
```

### Background Jobs
```bash
bundle exec sidekiq                  # Start Sidekiq worker
bundle exec sidekiq -C config/sidekiq.yml  # Start with custom config
```

### Docker Workflow
```bash
make docker:start    # Start containers with docker-compose
make docker:shell    # Enter app container shell
make docker:stop     # Stop containers
make docker:test     # Run tests in container
```

## Application Architecture

### Directory Structure

**Core Application** (`app/`):
- `components/` - ViewComponent widgets (PascalCase classes with matching kebab-case templates)
- `controllers/` - Rails controllers handling HTTP requests
- `models/` - ActiveRecord models and business logic
- `views/` - ERB templates and layouts
- `javascript/` - Frontend code compiled by Shakapacker:
  - `admin/` - Admin panel JS
  - `front/` - Public frontend JS
  - `homeland/` - Core application JS
  - `vendor/` - Third-party libraries

**Backend Services**:
- `jobs/` - ActiveJob background jobs
- `mailers/` - ActionMailer email templates
- `uploaders/` - CarrierWave file uploaders
- `sidekiq/` - Sidekiq job classes

**Extensibility**:
- `plugins/` - Reusable engines and forum extensions
- `lib/homeland/` - Core framework code
- `lib/single_sign_on.rb` - SSO provider/client logic
- `lib/tasks/` - Rake tasks

**Configuration**:
- `config/` - Rails configuration (see config/routes.rb for API structure)
- `config/initializers/` - Gem configurations
- `config/environments/` - Environment-specific settings

**Database & Testing**:
- `db/migrate/` - Database migrations
- `test/` - Minitest test suite (mirrors app/ structure)
- `test/factories/` - FactoryBot factories
- `test/fixtures/` - Test fixtures

### Key Technologies

- **Rails 8.0.3** - Web framework
- **Shakapacker 9.0** - Frontend asset compilation (Webpack wrapper)
- **PostgreSQL** - Primary database
- **Redis** - Caching and session storage
- **Sidekiq 6.5.12** - Background job processing
- **ViewComponent** - Component-based UI architecture
- **CarrierWave** - File upload management (supports Aliyun/Qiniu/Upyun)
- **Bootstrap 5.3** + Tailwind CSS 3.4 - UI framework
- **TypeScript 4.9** + JavaScript ES6+ - Frontend languages

### Authentication & Authorization

- **Devise** - User authentication (app/controllers/users/)
- **CanCanCan** - Authorization/permissions
- **Doorkeeper** - OAuth2 provider for API access
- **OmniAuth** - Social login (GitHub, Twitter, WeChat)
- **Custom SSO** - Single Sign-On support (lib/single_sign_on.rb)

### Main Resources

Based on routes configuration (config/routes.rb):
- Topics (forum discussions)
- Replies (topic comments)
- Users (authentication & profiles)
- Nodes (topic categories)
- Teams (user groups)
- Comments (general comments)
- Devices (mobile app support)
- OAuth Applications (API clients)

### Background Jobs

- Defined in `app/jobs/` and `app/sidekiq/`
- Scheduled via `config/schedule.yml` (Sidekiq-Cron)
- Examples: avatar generation, notification delivery, data cleanup

### File Upload System

- **Provider**: Configurable via `upload_provider` (.env)
- **Supported**: file (local), aliyun, qiniu, upyun
- **Uploaders**: `app/uploaders/base_uploader.rb`, `avatar_uploader.rb`, `photo_uploader.rb`
- **Image Processing**: MiniMagick for thumbnails and transformations

## Configuration

### Environment Variables

Key configurations in `.env` (override in `.env.local`):
- `RAILS_ENV` - Environment (development/production/test)
- `DATABASE_URL` - PostgreSQL connection string
- `REDIS_URL` - Redis connection string
- `secret_key_base` - Rails session encryption key
- `admin_emails` - Comma-separated admin email list
- `upload_provider` - File storage provider
- `sso_enable` / `sso_enable_provider` - SSO configuration
- `mailer_options.*` - SMTP settings

### Secrets Management

- Development: `.env` (gitignored) + `.env.local` (your overrides)
- Production: `config/credentials.yml.enc` (Rails 7+ encrypted credentials)
- Never commit production keys or real user data

## Development Workflow

### Testing Guidelines

- Uses **Minitest** (not RSpec)
- Test files mirror app structure: `test/models/user_test.rb`
- Place component tests in `test/components/`
- Integration tests in `test/integration/`
- Factories in `test/factories/` (FactoryBot)
- Run: `bundle exec rails test`

### Code Style

- **Ruby**: Two-space indentation, snake_case methods/vars, CamelCase classes
- **JavaScript/TypeScript**: camelCase functions, modular structure
- **Formatting**: Prettier for JS/TS (`npx prettier --write`), StandardRB for Ruby
- **ERB Templates**: Follow Rails conventions

### Contribution Process

- Concise, imperative commit messages (< 72 chars)
- PRs should explain motivation and summarize changes
- Highlight required migrations, env vars, or Sidekiq schedule updates
- Include screenshots/console output for UI/background job changes

### CI/CD Pipeline

GitHub Actions (`.github/workflows/test.yml`):
1. **AutoCorrect Check** - Validates text formatting
2. **Assets Compile** - Verifies frontend build works
3. **CI Test** - Runs full test suite with PostgreSQL & Redis

## Important Notes

- Uses **pnpm** as package manager (not npm/yarn)
- Frontend assets managed by **Shakapacker** (not Sprockets)
- **Sidekiq-Cron** for scheduled jobs (check `config/schedule.yml`)
- **Bootstrap 5.3** + custom CSS for styling
- **Turbolinks 5** for client-side navigation
- **Puma** app server (< v6 as per Gemfile)
- ImageMagick required for image processing (install via Homebrew/apt)
- On macOS ARM, use `rails s -u webrick` if Puma crashes

## Troubleshooting

- **Asset compilation errors**: Run `pnpm install` to ensure dependencies are up to date
- **Database connection issues**: Verify PostgreSQL is running (`docker-compose up` for local)
- **Redis connection errors**: Ensure Redis is running on configured port
- **Sidekiq jobs not running**: Check Sidekiq process and `config/sidekiq.yml`
- **Port conflicts**: Rails (3000), Shakapacker (3035), PostgreSQL (54321), Redis (63791)

## Additional Resources

- [Deployment Guide](https://homeland.ruby-china.org)
- [Configuration Docs](https://homeland.ruby-china.org/docs/configuration/config-file/)
- [Upload Configuration](https://homeland.ruby-china.org/docs/configuration/upload/)
- [SSO Documentation](https://homeland.ruby-china.org/docs/sso/)
- [CONTRIBUTE.md](https://github.com/ruby-china/homeland/blob/master/CONTRIBUTE.md) for detailed contribution guidelines

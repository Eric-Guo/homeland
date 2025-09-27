# Repository Guidelines

## Project Structure & Module Organization
Source code lives in `app/`, with Rails MVC directories plus `app/components` for ViewComponent widgets and `app/javascript` compiled by Shakapacker. Shared utilities sit in `lib/`, while reusable engines and forum extensions live under `plugins/`. Tests mirror the app layout inside `test/` (for example `test/controllers` and `test/components`), and static assets remain in `app/assets` and `public/`.

## Build, Test, and Development Commands
Run `bundle install` and `yarn install` after dependency changes. `bin/rails db:setup` (or `bin/rails db:migrate`) prepares the database, `bin/rails s` boots the app, and `yarn start` launches the live-reloading Shakapacker server. Docker workflows use `docker-compose up` plus Makefile helpers such as `make docker:start` and `make docker:shell`.

## Coding Style & Naming Conventions
Ruby uses two-space indentation, snake_case for methods and variables, and CamelCase for classes; run `bundle exec standardrb --fix` before committing. JavaScript and TypeScript in `app/javascript` should stay modular, use camelCase for functions, and be formatted with Prettier (`npx prettier --write app/javascript/**/*.{js,ts}`) including ERB partials via the Ruby plugin. Name ViewComponents under `app/components` with matching PascalCase classes and kebab-case templates.

## Testing Guidelines
Minitest drives coverage; place specs alongside code such as `test/models/user_test.rb` or `test/components`. Execute `bundle exec rails test` for the full suite or target folders with commands like `bundle exec rails test test/integration`. Update fixtures or factories in `test/fixtures` and `test/factories`, and add integration tests when altering authentication, jobs, or admin flows.

## Commit & Pull Request Guidelines
Emulate the existing history of concise, imperative commits (“gem upgrade”, “yarn upgrade”), keeping subject lines under 72 characters and expanding with bodies when context matters. Every PR should explain motivation, summarize key changes, and link related issues; include screenshots or console output for UI or background job updates. Call out required migrations, new environment variables, or Sidekiq schedule updates in the PR description.

## Security & Configuration Tips
Secrets load through `dotenv-rails`; keep local overrides in untracked `.env` files and use Rails credentials for shared secrets. Review changes in `config/initializers`, `config/settings`, and `plugins/` for security impact, especially around OAuth, throttling, or rate limits. Never commit production keys or sample data that resembles live user information.

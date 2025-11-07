# GEMINI.md

## Project Overview

This project is **Homeland**, a Ruby on Rails-based open-source forum/community website system. It is a full-featured discussion platform with topics, replies, user profiles, nodes (categories), and teams.

**Key Technologies:**

*   **Backend:** Ruby on Rails
*   **Database:** PostgreSQL
*   **Authentication:** Devise, Doorkeeper (OAuth2 provider), OmniAuth (GitHub, Twitter, WeChat)
*   **Authorization:** CanCanCan
*   **File Uploads:** CarrierWave with support for Aliyun, Upyun, and Qiniu
*   **Background Jobs:** Sidekiq
*   **Frontend:** Shakapacker (Webpack), Turbolinks, Sass, ViewComponent
*   **API:** Versioned JSON API (`/api/v3`)

**Architecture:**

The application follows a standard Ruby on Rails MVC architecture. It includes a comprehensive set of features, including:

*   Core forum functionality (topics, replies)
*   User authentication and authorization
*   OAuth2 provider capabilities
*   Third-party logins
*   Admin dashboard for site management
*   Background job processing for tasks like notifications
*   RESTful API for programmatic access

## Building and Running

**Prerequisites:**

*   Ruby
*   PostgreSQL
*   Redis
*   Node.js and pnpm

**Setup and Running:**

1.  **Install dependencies:**
    ```bash
    bundle install
    pnpm install
    ```

2.  **Create and setup the database:**
    ```bash
    rake db:create
    rake db:migrate
    rake db:seed
    ```

3.  **Run the development server:**
    ```bash
    ./bin/dev
    ```

**Testing:**

To run the test suite:

```bash
rake test
```

## Development Conventions

*   **Code Style:** The project uses RuboCop for Ruby code style enforcement. The configuration is in `.rubocop.yml`.
*   **Testing:** The project uses Minitest for testing. Tests are located in the `test/` directory. Factory Bot is used for creating test data.
*   **Contributions:** The `CONTRIBUTE.md` file provides guidelines for contributing to the project.

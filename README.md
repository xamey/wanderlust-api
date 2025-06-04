# Rails JWT authentication starter

A minimal Rails 8 starter application that implements JWT (JSON Web Token) based authentication instead of the traditional cookie-based authentication.

## Getting Started

1. Clone the repository:

   ```bash
   git clone <your-repo-url>
   cd rails-with-jwt
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   bin/rails db:create db:migrate
   ```

4. Start the Rails server:
   ```bash
   bin/rails server
   ```

The application will be available at `http://localhost:3000`.

## Authentication Flow

### Sign Up

Sign up is up to you to implement.
You can create an user in console using `User.create!(email_address: "test@test.fr", password: "test")` for example.

### Sign In

1. Send a POST request to `/session` with payload as `{"email_address": string, "password": string}`
2. Upon successful authentication, you'll receive a payload as `{"jwt": string}`
3. Include this token in subsequent requests in the Authorization header:
   ```
   Authorization: Bearer <your-jwt-token>
   ```

### Sign Out

- Send a DELETE request to `/session` with your JWT token
- The session will be terminated and the token invalidated

### Ask for a password reset

- Send a POST to `/passwords` with payload as `{"email_address": string}`
- If an user is found, a reset token will be generated and accessible under `user.password_reset_token` and an email will be sent

### Modify the password

- Send a PUT to `/passwords/:token` with payload as `{"password": string, "password_confirmation": string}`
- It should redirect you accordingly to the status: successful or failing

## API Endpoints

### Authentication

- `POST /session` - Sign in
- `DELETE /session` - Sign out
- `POST /passwords` - Request password reset
- `PUT /passwords/:token` - Reset password

Here's the [Postman API documentation](https://documenter.getpostman.com/view/25637739/2sB2qi9yFM)

## License

This project is licensed under the MIT License.

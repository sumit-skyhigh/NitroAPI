# NitroAPI

NitroAPI is a boilerplate project to quickly set up a web API with identity management out of the box. It supports JWT (JSON Web Token) generation, making it easy to secure your API endpoints. With NitroAPI, you can start an API project, register your first user in the database, and receive a JWT token within minutes. The project initialization process is streamlined to avoid any hassles.

## Features

- **Identity Configured Out of the Box**: Includes JWT generation for secure authentication.
- **Quick Start**: Register your first user and receive a JWT token within minutes.
- **Hassle-free Project Initialization**: Automated scripts to set up the project structure, dependencies, and configurations.

## Getting Started

Follow these steps to get your NitroAPI project up and running.

### Prerequisites

- .NET 8.0
- Entity Framework Core CLI

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/sumit-skyhigh/NitroAP
    cd NitroAPI
    ```

2. Run the initialization script:
    ```powershell
    .\init.ps1
    ```

    The script will prompt you for a project name. Enter a valid name (alphanumeric characters and underscores only).

### Project Structure

The initialization script will create the following directory structure:
```
$projectName/
└── src/
    └── $projectName.Api/
        ├── Controllers/
        ├── Data/
        ├── Dtos/
        │   └── Account/
        ├── Helpers/
        ├── Interfaces/
        ├── Mappers/
        ├── Models/
        ├── Repositories/
        └── Services/
```

### Configuration

The script sets up the necessary configurations, including:

- **Database Connection**: Configured to use SQLite.
- **Identity and JWT**: Configured for user authentication and authorization.
- **Swagger**: Integrated for API documentation.

### Running the Project

1. Navigate to the project directory:
    ```sh
    cd $projectName/src/$projectName.Api
    ```

2. Add the initial migration and update the database if:
    ```sh
    dotnet ef migrations add InitialCreateWithIdentity
    dotnet ef database update
    ```

3. Run the project:
    ```sh
    dotnet watch run
    ```

### Registering a User

To register a new user, send a POST request to `/api/account/register` with the following JSON payload:

```json
{
    "username": "newuser",
    "email": "newuser@example.com",
    "password": "YourPassword123!"
}
```

### Logging in

To log in, send a POST request to `/api/account/login` with the following JSON payload:

```json
{
    "username": "newuser",
    "password": "YourPassword123!"
}
```

You will receive a JWT token in response. Use this token to authenticate subsequent requests.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License.

---

NitroAPI provides a quick and efficient way to set up a secure, user-authenticated dotnet web API project with minimal hassle. Get started today and save valuable development time!

# NitroAPI

NitroAPI is a boilerplate project to quickly set up a web API with identity management out of the box. It supports JWT (JSON Web Token) generation, making it easy to secure your API endpoints. With NitroAPI, you can start an API project, register your first user in the database, and receive a JWT token within minutes. The project initialization process is streamlined to avoid any hassles.

## Motivation
Setting up a project from the ground up can be boring and frustrating.  Our goal is to let you focus on writing the fun parts of your application, not the boilerplate code.

## Design Principles
- **Less is More:** Minimize unnecessary steps and clicks.
- **It Just Works:** Simplify the setup process to be as straightforward as possible.
- **Convention Over Configuration:** Use sensible defaults to reduce configuration.
- **Focus on the Fun Part:** Allow developers to spend more time on the interesting parts of their projects rather than the enviornment setup and boilerplate code.
- **Good Project Structure:** Ensure a well-organized project structure to prevent common pain points.

## Features
- **Identity Configured Out of the Box:** Includes an implementaion of JWT generation for secure authentication and authorization of API endpoints.
- **Quick Start:** Register your first user and receive a JWT token within minutes.
- **Hassle-free Project Initialization:** Automated scripts to set up the project structure, dependencies, and configurations.
- **Modern .NET 8 Support:** Utilizes the latest .NET 8 framework with ASP.NET Web API templates.
- **Standard Directory Structure:** Provides a loosely coupled repository pattern for web API projects.
- **Built-in Identity Authorization & Authentication:** Integrates Microsoft Identity for secure authorization and authentication, requiring SQL Server or similar for testing.
- **Swagger Support:** Includes Swagger for API documentation and testing, complete with authorization functionalities.
- **Ready-to-Use Project Template:** A well-structured template with repository pattern, authentication, authorization, and database connectivity, ready to go with a single command. No need to manage NuGet package versions manually.

## Getting Started
Follow these steps to get your NitroAPI project up and running.

### Prerequisites
- .NET 8.0
- Entity Framework Core CLI

### Getting Started with NitroAPI

Generation of a NitroAPI project is simple and straightforward. Follow these steps to create your project:

#powershell script

    ```powershell
    git clone https://github.com/sumit-skyhigh/NitroAPI
    cd NitroAPI    
    .\init.ps1
    ```
    

The script will prompt you for a project name. Enter a valid name (alphanumeric characters and underscores only) and press Enter. The script will then set up the project structure, install dependencies, and configure the project for you. Also it will itilitize git repository and migrate the database for testing using SQLite. 



### Project Structure

The initialization script will create the following directory structure for your project for you to start coding right away:
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

- **Database Connection**: Configured to use SQLite. You can change the connection string in `appsettings.json` to use a different database provider. 

- **Identity and JWT**: Configured for user authentication and authorization using Microsoft.AspNetCore.Identity. JWT generation is also set up using Microsoft.AspNetCore.Authentication.JwtBearer.

- **Swagger**: Integrated for API documentation and testing. It's preconfigure to authhorize with JWT token. So, you can easily test your authorized API endpoints with Swagger. No need to build a separate client to test API endpoints or use tools like Postman or Curl.

# What's Coming

## Entity Relationships:
- Simple
- One-to-One (1:1)
- One-to-Many (1:N)
- Many-to-Many (N:M)

## Test Projects:
Add test projects to ensure code quality.

## CI/CD Functionality:
Out-of-the-box support for CI/CD using:
- Docker
- Jenkins
- Terraform

## Microservice Template:
A template for building microservices.

## Cloud Vendor Support:
Integration with popular cloud vendors:
- Azure
- AWS
## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes. Feel free to contribute or suggest features. This project is developed in my free time, but interesting suggestions will be considered for implementation.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

NitroAPI provides a quick and efficient way to set up a secure, user-authenticated dotnet web API project with minimal hassle. Get started today and save valuable development time!

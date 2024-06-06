using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Example.Api.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace Example.Api.Helpers
{
    public class QueryObject
    {   
        // Pagination     
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 20;
    }
}

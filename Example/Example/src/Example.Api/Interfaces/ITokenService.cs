using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Example.Api.Models;

namespace  Example.Api.Interfaces
{
    public interface ITokenService
    {
        string CreateToken(AppUser user);
    }
}

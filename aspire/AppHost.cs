var builder = DistributedApplication.CreateBuilder(args);

var web = builder.AddCSharpApp("web", "../src/DataStarWut.Web/");

builder.Build().Run();

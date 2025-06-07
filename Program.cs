using Microsoft.Extensions.DependencyInjection;
using Pulumi;

return await Deployment.RunAsync(() =>
{
    var services = new ServiceCollection()
        .AddServices()
        .BuildServiceProvider();

    var volume = services.GetRequiredService<IVolume>().Build();

    var webServer = services.GetRequiredService<IDevice>();
    webServer.Start();
});

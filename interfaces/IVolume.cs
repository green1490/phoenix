using Pulumi;
using Pulumi.Libvirt;

public interface IVolume
{
    Volume Build();
    public Output<string> GetId();
}
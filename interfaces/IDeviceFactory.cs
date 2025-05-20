using System;

public interface IDeviceFactory
{
    public IDevice CreateDevice(string deviceType, string volumeType);
}
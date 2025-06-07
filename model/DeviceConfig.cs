public record DeviceConfig
{
    public double Vcpu { get; init; }
    public double Memory { get; init; }
    public string? Volume { get; init; }
    public required string Name { get; init; }
    public string? Subnet { get; set; }
}
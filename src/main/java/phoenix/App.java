package phoenix;

import com.pulumi.Pulumi;
import com.pulumi.core.Output;
import com.pulumi.libvirt.Domain;
import com.pulumi.libvirt.DomainArgs;
import com.pulumi.libvirt.LibvirtFunctions;
import com.pulumi.libvirt.Provider;
import com.pulumi.libvirt.ProviderArgs;
import com.pulumi.libvirt.inputs.DomainCpuArgs;
import com.pulumi.libvirt.inputs.DomainDiskArgs;

public class App {
    public static void main(String[] args) {
        Pulumi.run(ctx -> {
            
            // connecting to QEMU
            var provider = new Provider(
                    "libvirtd",
                    ProviderArgs.builder()
                    .uri("qemu:///system")
                    .build()
                );
            
            var router = new Domain(
                "Router", 
                DomainArgs.builder()
                .vcpu(3)
                .memory(512)
                .description("Routes traffic between 2 virtual machine")
                .disks(
                    DomainDiskArgs.builder()
                    .file("/var/lib/libvirt/images/kali-linux-2024.4-installer-amd64.iso")
                    .build()
                    )
                    .build()
                    );
            ctx.export("Domain", Output.of("Domain"));
        });
    }
}

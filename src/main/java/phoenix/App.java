package phoenix;

import com.pulumi.Pulumi;
import com.pulumi.core.Output;
import com.pulumi.libvirt.Domain;
import com.pulumi.libvirt.DomainArgs;
import com.pulumi.libvirt.Provider;
import com.pulumi.libvirt.ProviderArgs;
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
                .vcpu(3.0)
                .memory(512.0)
                .description("Routes traffic between 2 virtual machine")
                .disks(
                    DomainDiskArgs.builder()
                    .url("https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/cloud/nocloud_alpine-3.21.2-x86_64-bios-cloudinit-metal-r0.qcow2")
                    .build()
                    )
                .build()
                );
            ctx.export("Domain", Output.of("Domain"));
        });
    }
}

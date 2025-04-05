package phoenix;

import com.pulumi.Pulumi;
import com.pulumi.core.Output;
import com.pulumi.libvirt.Domain;
import com.pulumi.libvirt.DomainArgs;
import com.pulumi.libvirt.Provider;
import com.pulumi.libvirt.ProviderArgs;
import com.pulumi.libvirt.Volume;
import com.pulumi.libvirt.VolumeArgs;
import com.pulumi.libvirt.inputs.DomainDiskArgs;

import phoenix.model.VirtualMachineBuilder;;

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
            
            VirtualMachineBuilder vm = new VirtualMachineBuilder("router");
            vm.build();

            ctx.export("Domain", Output.of("Domain"));
        });
    }
}

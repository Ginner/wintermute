{ config, pkgs, lib, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "mailias";
      
      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/usr/bin/env bash
        
        # Function to display usage
        usage() {
          echo "Usage: $0 <from_alias> <to_address>"
          echo "Example: $0 from@myalias.com to@receiver.net"
          exit 1
        }

        # Check if we have the correct number of arguments
        if [ $# -ne 2 ]; then
          usage
        fi

        # Get the input parameters
        from_alias="$1"
        to_address="$2"

        # Extract the parts of the from_alias
        from_user=$(echo "$from_alias" | cut -d@ -f1)
        from_domain=$(echo "$from_alias" | cut -d@ -f2)

        # Replace @ with = in the to_address
        formatted_to=$(echo "$to_address" | sed 's/@/=/')

        # Construct the final address
        final_address="${from_user}+${formatted_to}@${from_domain}"

        # Output the result
        echo "$final_address"
      '';
    })
  ];
}

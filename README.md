                                   ---.           ,-----,       --,                                               
                                  /\\\\\           \OOO0\      /OO0\                                              
                                  \/\\\\\           \OOO0\    /OOOO\                                              
                                   \/\\\\\           \OOO0\  /OOOO/                                               
                                    \/\\\\\           \OOO0\/OOOO/                                                
                              -------\/\\\\\---------  \OOOOOOOO/                                                 
                             ///////////////////////\\  \OOOOOO/                                                  
                            /\\\\\\\\\\\\\\\\\\\\\\\\\\  \OOOO0\                                                  
                           ****************************   \00000\                                                 
                                                           \OOO00\                                                 
                                  ,-----                    \O0000\    \                                                     
                                 /OOOOO/                     \00000/  /\\                                                    
                                /OOOOO/                       \000/  /\\\\                                                   
                               /0OOOO/                         \0/  /\\\\/`                                                  
                              /00OOO/                           /  /\\\\//                                                   
                ,-===========/000OO/                              //\\\//                                                    
                \0000OOOOOOOOOOOOO/                              //\\\//                                                     
                 \00000OOOOOOOOOO/                              //\\\/---------                                              
                  `*******/OOOOO/                              /\\\\\\\\\\\\\\\\                                             
                         /OOOOO/                              /\\\\\////////////;                                            
                        /OOOOO/                              /\\\\/************'                                             
                       /0OOOO/  \                           /\\\\//                                                          
                      \00OOO/  *\\                         /\\\\//                                                           
                       \000/  *///\                       /\\\\//                                                            
                        \0/  */////\                     /\\\\//                                                             
                         `    */////\                   *******                                                             
                               */////\                                                                                         
                                */////\  =============================                                                   
                                 */////\  \000OOOOOOOOOOOOOOOOOOOOOO/                                                    
                                 ///////\  \00000OOOOOOOOOO0000OOOO/                                                     
                                /////////\  `********`\OOOO\*******                                                      
                               ////\\//\//\            \OOOO\                                                            
                              ////\\/ \/\//\            \0OOO\                                                           
                             ////\\/   \/\//\            \00OO\                                                          
                             *//\\/     \/\//\            \0000\                                                         
                              ****       ``***`            ****                                             

Layout:
- `hosts/nixos/default.nix`: host entrypoint
- `profiles/headless.nix`: low-backlight, lid-open server profile
- `profiles/interactive.nix`: Hyprland desktop profile
- `modules/`: shared system modules
- `home/mfkd/default.nix`: shared user environment managed by Home Manager
- `home/mfkd/desktop.nix`: interactive-only Hyprland user environment
- `local.nix`: host-local overrides such as authorized keys

Build or activate the headless system:

```bash
sudo nixos-rebuild switch --flake path:/etc/nixos#nixos
```

Build or activate the interactive system:

```bash
sudo nixos-rebuild switch --flake path:/etc/nixos#nixos-interactive
```

The interactive profile keeps the console login instead of running a display
manager. Logging in as `mfkd` on `tty1` starts an UWSM-managed Hyprland
session automatically. Other TTYs and SSH sessions remain normal shells. Set a
working local password with `passwd` before activating the interactive profile;
the same password is used by Hyprlock.

Home Manager generations remain available in either profile:

```bash
home-manager generations
```

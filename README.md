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
- `modules/`: shared system modules
- `home/mfkd.nix`: user environment managed by Home Manager
- `local.nix`: untracked host-local overrides such as authorized keys

Common commands:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
home-manager generations
```

- create `ap_handler` object with 
  - Create
  - Other > Async Networking (other_68)
  - Other > Room Start (other_4)
- add `instance_create_layer(0, 0, "Instances", ap_handler)` to `gml_Object_initiategame_Create_0`
- add `gml_GlobalScript_ap` to Global init

- the apworld currently included is a manual client apworld and is used to just generate a world, it should go under `Archipelago` -> `lib` -> `worlds` -> `vividstasis`
  - in the options set `Betweenspace_Crystalsanity` to true, otherwise it fails to generate
function demo_reg3DNR()

  % Get the volume data
  [Imoving,Istatic]=get_example_data;

  % Register the images
  Ireg = register_volumes(Imoving,Istatic);

  % Show the results
  showcs3(Imoving);
  showcs3(Istatic);
  showcs3(Ireg);
end
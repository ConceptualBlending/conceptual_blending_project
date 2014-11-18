
To run the blending system, open a console
 go to the local directory where the 'source' folder is located

make sure you have latest version of ruby installed

type "ruby begin_process.rb" 
 without double quotes of course!

The system still has error while sending file to hets.


Files which are part of the blending system:

--- data file:



--- processing files
1. createMonster.rb
---> the main file 
2. selectInputSpaces.rb
---> selects the input spaces from the given repository 
3. findBase.rb
---> finds the base and base morphisms in the given input spaces
4. makeInputForHets.rb
---> generates the '*.dol' file
5. createBlend.rb
---> calls hets to generate the blendoid
6. checkBlendConsistent.rb
---> calls hets to test the consistency of the blendoid
7. weakenInput.rb
---> weakens the input spaces
8. checkRequirementSatisfaction.rb
---> calls hets to test the requirement satisfaction by the blendoid



--- data structure files
1. data.rb
---> data structure for ontology















To run the blending system, open a console
 go to the local directory where the 'source' folder is located

make sure you have latest version of ruby installed

type "ruby create.rb" 
 without double quotes of course!

The system still has error while sending file to hets.


Files which are part of the blending system:

--- data file:
1. input.dol
---> contains the input space, base, base morphisms, blend command for hets, evaluation query to generate blend and to evaluate blend


--- processing files
1. create.rb
---> the main file
2. makeBlendPattern.rb
---> method for creating a pattern, for limited pattern use 
3. selectInput.rb
---> method for selecting input spaces
4. makeBase.rb
---> method for creating base, to-do student project
5. makeInputFile.rb
---> method that combines input space, base, morphisms, blend command, evaluation query to send it to HETS
6. makeEvaluationQuery.rb
---> method that generates the query for evaluation
7. makeEvaluation.rb
---> method for checking consistency and requirement satisfaction
8. weakenInput.rb
---> method for weakening the input


--- data structure files
1. makeBKForm.rb
---> data structure for background knowledge
2. makeInputForm.rb
---> data structure for input space
3. makeBaseForm.rb
---> data structure for base
4. makeSharedStructureForm.rb
---> data structure to store the discovered shared data structure by makeBase.rb, needs improvement
5. makeMorphismForm.rb
---> data structure for base morphisms, currently developed for v-style blending pattern
6. makeBlendoidForm.rb
---> data structure for combining input spaces and morphisms to generate blend













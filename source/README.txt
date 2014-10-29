
To run the blending system, open a console
 go to the local directory where the 'source' folder is located

make sure you have latest version of ruby installed

type "ruby create.rb" 
 without double quotes of course!

The system still has error while sending file to hets.


Files which are part of the blending system:

--- data file:
input.dol					: contains the input space, base, base morphisms, blend command for hets, evaluation query to generate blend and to evaluate blend


--- processing files
create.rb					: the main file
makeBlendPattern.rb			: method for creating a pattern, for limited pattern use 
selectInput.rb				: method for selecting input spaces
makeBase.rb					: method for creating base, to-do student project
makeInputFile.rb			: method that combines input space, base, morphisms, blend command, evaluation query to send it to HETS
makeEvaluationQuery.rb		: method that generates the query for evaluation
makeEvaluation.rb			: method for checking consistency and requirement satisfaction
weaken_input.rb				: method for weakening the input


--- data structure files
makeBKForm.rb				: data structure for background knowledge
makeInputForm.rb			: data structure for input space
makeBaseForm.rb				: data structure for base
makeSharedStructureForm.rb	: data structure to store the discovered shared data structure by makeBase.rb, needs improvement
makeMorphismForm.rb			: data structure for base morphisms, currently developed for v-style blending pattern
makeBlendoidForm.rb			: data structure for combining input spaces and morphisms to generate blend













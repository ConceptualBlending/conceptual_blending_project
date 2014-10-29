
# this method is used to generate the query for checking the consistency and requirement satisfaction
# 

def make_Evaluation_Query(blend, bKnowledge)

	query_structure = {:query_ontology => "ontology",
						:query_name => "monster_evaluate",
						:query_blend => blend,
						:query_check => bKnowledge,
						:query_separate => "and",
						:query_name_end => "="		
						}

	return query_structure


end

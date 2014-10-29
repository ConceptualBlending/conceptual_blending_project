
require "open-uri"


def test_download
#	remote_base_url = "http://en.wikipedia.org/wiki"
#	remote_page_name = "Ada_Lovelace"
	remote_full_url = "https://ontohub.org/animal_monster/animalKnowledge.owl"

	remote_data = open(remote_full_url).read
	my_local_file = open("my-downloaded-page.txt", "w") 

	my_local_file.write(remote_data)
	my_local_file.close

	return
end

test_download()

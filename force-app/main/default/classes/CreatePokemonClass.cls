
public with sharing class CreatePokemonClass {

    public static void createPokemon(Integer startIndex){

        try {

            Integer lengthFor = startIndex + 99;

            List<Pokemon__c> pokemonToInsert = new List<Pokemon__c>();

            for (Integer i = startIndex; i < lengthFor; i++) {

                Http http = new Http();

                HttpRequest req = new HttpRequest();

                req.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + i);

                req.setMethod('GET');

                req.setHeader('Content-Type', 'application/json');

                HttpResponse res = http.send(req);

                String body = res.getBody();

                System.debug('Body String ' + body);

                pokemon pok = (pokemon) JSON.deserialize(body, pokemon.Class);

                Pokemon__c pokemonObject = new Pokemon__c();

                pokemonObject.Name = pok.name.Capitalize();

                pokemonObject.Altura__c = pok.height.format() + ' (ft)';

                pokemonObject.Foto_URL__c = (pok.sprites.other.home.front_default == null)

                  ? pok.sprites.front_default

                  : pok.sprites.other.home.front_default;

                pokemonObject.Peso__c = pok.weight + ' (lb)';

                pokemonObject.PokeIndex__c = pok.id;
                
                System.debug(pok.id);
               
                if (pok.id <= 151) {
                    pokemonObject.Generacion__c = 1;
                  } else if (pok.id >= 152 && pok.id <= 251) {
                    pokemonObject.Generacion__c = 2;
                  } else if (pok.id >= 252 && pok.id <= 386) {
                    pokemonObject.Generacion__c = 3;
                  } else if (pok.id >= 387 && pok.id <= 493) {
                    pokemonObject.Generacion__c = 4;
                  } else if (pok.id >= 494 && pok.id <= 649) {
                    pokemonObject.Generacion__c = 5;
                  } else if (pok.id >= 650 && pok.id <= 721) {
                    pokemonObject.Generacion__c = 6;
                  } else if (pok.id >= 722 && pok.id <= 809) {
                    pokemonObject.Generacion__c = 7;
                  } else if (pok.id >= 810) {
                    pokemonObject.Generacion__c = 8;
                  }
                
                System.debug(pokemonObject.Generacion__c);
                  for (Integer j = 0; j < pok.types.size(); j++) {
                    pokemonObject.Tipo__c = pokemonObject.Tipo__c == null
                      ? pok.types[j].type.name
                      : pokemonObject.Tipo__c + ';' + pok.types[j].type.name;
                  }

                pokemonToInsert.add(pokemonObject);
                

            }

            insert pokemonToInsert;

          } catch (Exception e) {

            System.debug('ERROR :' + e);

          }

    }

}
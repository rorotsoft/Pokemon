//procesa datos en lotes (batch) en apex
//implementa database.batchable, para realizar las operacioenes por loter
//usa database.allowscallouts para llamadas a servicios web externos
//usa database.stateful, para mantener el estado entre las ejecuciones del lote
global class PokemonBatch implements Database.Batchable<Pokemon__c>, Database.AllowsCallouts, Database.Stateful {
    public List<Pokemon__c> pokLst; //pokLst: lista que almacena registros de obj personalizados
                                    //los registros se pasan al constructor cuando se instancia el lote
    public PokemonBatch(List<Pokemon__c> pokLst) {
      this.pokLst = pokLst;
    } //acepta la lista de objetos como argumento y almacena en pokLst
 
  
    //el metodo start lo usa la interfaz database.batchable 
    //y devuelve un iterable de registros que se procesan en lotes. (ACA DEVUELVE LALISTA )
  global Iterable<Pokemon__c> start(Database.BatchableContext BC) {
      return pokLst;
    }
  
   //metodo execute: se realiza la mayor parte del trabajo del lote
    global void execute(
      Database.BatchableContext BC,
      List<Pokemon__c> ListPokemonToInsert
    ) {
      try {
        //se inicia una solicitud HTTP para obtener los datos de la API, usando PokeIndex__c
        Http http = new Http(); 
        HttpRequest req = new HttpRequest();
  
        req.setEndpoint(
          'https://pokeapi.co/api/v2/pokemon/' +
          ListPokemonToInsert[0].PokeIndex__c
        );
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
              HttpResponse res = http.send(req);
        String body = res.getBody();
        //se proesa el JSOn recibido y se crea un objeto pokemon, usando el metodo parse
        pokemon pok = pokemon.parse(body);
  
        //se crea un registro de objeto Pokemon__c y se asignan los valores obtenidos de la API
        Pokemon__c pokemonObject = new Pokemon__c();
        pokemonObject.Name = pok.name.Capitalize();
        pokemonObject.Altura__c = pok.height.format() + ' (ft)';
        pokemonObject.Foto_URL__c = (pok.sprites.other.home.front_default == null)
          ? pok.sprites.front_default
          : pok.sprites.other.home.front_default;
        pokemonObject.Peso__c = pok.weight + ' (lb)';
        pokemonObject.PokeIndex__c = pok.id;
  
   
        //logica para determinar la generacion del pokemon en funcion de su ID
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

        //se itera sobre los tipos de pokemon y se los concatena en un campo (Tipo__c)
        for (Integer i = 0; i < pok.types.size(); i++) {
          pokemonObject.Tipo__c = pokemonObject.Tipo__c == null
            ? pok.types[i].type.name
            : pokemonObject.Tipo__c + ';' + pok.types[i].type.name;
        }
  
   
        //manejo de errores
        //cualquier excepcion que se produzca durante el procesamiento se captura en un bloque catch
        insert pokemonObject;
      } catch (Exception e) {
        System.debug('ERROR :' + e);
      }
    }
  
   
  
    global void finish(Database.BatchableContext BC) {
      System.debug('El batch se termina de ejecutar');
    }
  }
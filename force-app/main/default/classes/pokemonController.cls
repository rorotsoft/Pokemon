//clase diseñada para ser usasada en una app de salesforce lightning
//la clase tiene metodos decorados con anotacion QAuraEnabled
//lo que los hace disponibles para ser invocados desde componentes Lightning
//y permiten que se almacenen en cache para mejorar rendimiento
public with sharing class pokemonController {
    @AuraEnabled(Cacheable=true)
    
    //este metodo se usa para obtener una lista de todos los registros de objetos Pokemon__C desde salesforce
    public static Pokemon__c[] getAllPokemons() {
    //los registro se recuperan mediante una consulta SOQL
    // salesforce object query language
    
      return [
        SELECT
          Id,
          Name,
          Altura__c,
          Peso__c,
          Generacion__c,
          Tipo__c,
          Foto_URL__c,
          PokeIndex__c
        FROM Pokemon__c
        WITH SECURITY_ENFORCED
        ORDER BY PokeIndex__c
        LIMIT 899
      ];
    }
  
   
  
    @AuraEnabled(Cacheable=true)
    //este metodo permite buscar registros basados en ciertos criterios de busqueda
    public static Pokemon__c[] searchPokemons(
      String tipo,
      Integer generacion,
      String searchTerm
    ) {
      searchTerm = searchTerm.trim();
      
      /*El método limpia el término de búsqueda eliminando espacios en
       blanco al principio y al final, y luego agrega comodines '%' para realizar una búsqueda parcial en el nombre del Pokémon.*/
      searchTerm = '%' + searchTerm + '%';
  
      /*Construye una consulta SOQL dinámica para buscar registros de Pokémon que coincidan con los criterios especificados. */
      String query = 'SELECT Id, Name, Altura__c, Peso__c, Generacion__c, Tipo__c, Foto_URL__c, PokeIndex__c FROM Pokemon__c';
  
      
  
      if (searchTerm != '') {
        query += ' WHERE Name LIKE :searchTerm ';
      }
      if (tipo != 'Todos') {
        query += ' AND Tipo__c INCLUDES(:tipo) ';
      }
      if (generacion != 0) {
        query += ' AND Generacion__c =:generacion ';
      }
      query += ' ORDER BY PokeIndex__c';
  
   
  
      return Database.query(query);
    }
  }
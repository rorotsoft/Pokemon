//esta clase implementa la interfaz HttpCalloutMock en salesforce.
public class PokemonBatchMock implements HttpCalloutMock {
   //variables miembro que se utilizan para almacenar inf sobre la respuesta simulada 
    protected Integer code; //int representa el codigo de estado HTTP de la respuesta
    protected String status; //cadena que represeta el msj de estado HTTP de la resp.
    protected String bodyAsString; //cadena que representa el cuerpo de la respuesta en formato txt.
    protected Blob bodyAsBlob; //objeto Blob que se usa para representar el cuerpo de la resp en formato binario
    protected Map<String, String> responseHeaders; //mapa que almacena los encabezados de respuesta HTTP
  
   
  //constructor acepta varios parametros que se usan para iniciar las variables miembro
    public PokemonBatchMock(
      Integer code,
      String status,
      String body,
      Map<String, String> responseHeaders
    ) {
      this.code = code;
      this.status = status;
      this.bodyAsString = body;
      this.bodyAsBlob = null;
      this.responseHeaders = responseHeaders;
    }
  
   
  //metodo respond, requerido por HttpCalloutMock, se llama cuando se realiza una llamada HTTP simulada
    public HTTPResponse respond(HTTPRequest req) {
      //se crea un objeto , se usa para representar la respuesta HTTP
      HttpResponse resp = new HttpResponse();
     //se establece el codigo de estado y el msj en el objeto resp
      resp.setStatusCode(code);
      resp.setStatus(status);
      //en este caso el cuerpo se establece como una cadena
      if (bodyAsBlob != null) {
        //resp.setBodyAsBlob(bodyAsBlob);
      } else {
        resp.setBody(bodyAsString);
      }
  
   
      //devuelve como resultado de la simulacion de la llamada HTTP.
      return resp;
    }
  }
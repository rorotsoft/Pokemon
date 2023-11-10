public class pokemon {

    //variables publicas para almacenar inf
    public Integer height; 
    public Integer id; 
    public String name; 
    public Integer order; 
    public cls_sprites sprites;
    public cls_types[] types;
    public Integer weight; 

    //clases internas: se usan para estructurar y organizar los datos

    public class cls_sprites { //almacena inf relacionados con las img
      public String front_default; 

      public cls_other other; 
    }
   /* class cls_back_female {
    }
    class cls_back_shiny_female {
    }
    class cls_front_female {
    }
    class cls_front_shiny_female {
    }*/
    public class cls_types { 
      public Integer slot; //posicion
      public cls_type type; //representa la inf del tipo 
    }
    public class cls_other {
      public cls_home home;
    }
    public class cls_home {
      public String front_default;
    }
    public class cls_type { //inf sobre el nombre y la URL
      public String name; 
      public String url; 
    }

    //metodo estatico convierte los datos JSON en un objeto de apex
    public static Pokemon parse(String json) {
      return (Pokemon) System.JSON.deserialize(json, Pokemon.class);
    }
  }
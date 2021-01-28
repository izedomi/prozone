class Gallery{
    
    int id;
    String portfolioId;
    String imagePath;

    Gallery({
      this.id,
      this.portfolioId,
      this.imagePath
    });


    factory Gallery.createGallery(Map<String, dynamic> json){
       
        return Gallery(
          id: json['id'],
          portfolioId: json['portfolio_id'],
          imagePath: json['image_path'],
        );   
    }

}
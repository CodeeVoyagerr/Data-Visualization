Table table; // Tablo değişkeni
boolean isMouseOverCircle = false; // Fare dairenin içinde mi?
boolean hasSongPrinted = false; // Şarkı adının bir kere yazıldığını belirtmek için işaretçi
ArrayList<PVector> circlePositions = new ArrayList<PVector>(); // Dairelerin konumlarını saklamak için ArrayList

void setup() {
  size(1980, 1000);
  
  // .csv dosyasını yükle
  table = loadTable("spotify-2023.csv", "header,csv");
  
  // Görselleştirme için ayarlar
  background(255);
  
  // Verileri daire olarak çiz
  drawCircleChart();
}

void drawCircleChart() {
  // Veri setindeki her satır için döngü
  for (int i = 0; i < table.getRowCount(); i++) {
    // İlgili satırı al
    TableRow row = table.getRow(i);
    
    // Dairenin konumu ve boyutunu belirle
    PVector newPos;
    do {
      float x = random(width);
      float y = random(height);
      newPos = new PVector(x, y);
    } while (checkCollision(newPos));
    
    // Daireyi çiz
    float radius = sqrt(row.getFloat("streams")) / 1100; // Stream sayısına göre dairenin büyüklüğünü ayarla 
    circlePositions.add(newPos); // Yeni konumu listeye ekle
    fill(0, 200, 250); // Mavi renkte daireler
    stroke(0, 200, 250); // Daire çevresi mavi renkte
    ellipse(newPos.x, newPos.y, radius, radius);
  }
}

void draw() {
  isMouseOverCircle = false; // Fare dairenin içinde mi?

  // Dairelerin üzerine gelindiğinde şarkı adını göster
  for (int i = 0; i < circlePositions.size(); i++) {
    PVector pos = circlePositions.get(i);
    float radius = sqrt(table.getRow(i).getFloat("streams")) / 3000;
    
    // Eğer fare dairenin içindeyse
    if (dist(mouseX, mouseY, pos.x, pos.y) < radius / 2) {
      isMouseOverCircle = true; // Fare dairenin içinde
      if (!hasSongPrinted) { // Şarkı adı daha önce yazılmadıysa
        textAlign(CENTER);
        fill(0);
        text(table.getRow(i).getString("track_name"), pos.x, pos.y + radius / 2);
        hasSongPrinted = true; // Şarkı adının yazıldığını işaretle
      }
      break; // Şarkı adını sadece bir kez yazdırmak için döngüden çık
    }
  }
  
  // Eğer fare dairenin dışında ise ve herhangi bir dairenin içine girilmemişse, işaretçiyi sıfırla
  if (!isMouseOverCircle) {
    hasSongPrinted = false;
    // Arka planı temizlemeye gerek yok
  }
}

boolean checkCollision(PVector newPos) {
  // Yeni konumun diğer dairelerle çakışıp çakışmadığını kontrol et
  for (PVector pos : circlePositions) {
    if (dist(newPos.x, newPos.y, pos.x, pos.y) < 35) { // Belirli bir mesafeden daha yakınsa çakışma var demektir
      return true; // Çakışma var
    }
  }
  return false; // Çakışma yok
}

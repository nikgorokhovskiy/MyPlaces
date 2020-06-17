# MyPlaces
This app for saving places like a shops, restaurants and rest zones etc. Allows you to create an entry in the list with the address and a photo of the selected place.

This app using tableView and mapView. As a database is Realm. You can use the camera or gallery to add photos.

Краткое описание работы приложения:

При запуске пользователь попадает на главный экран приложения. Здесь размещается список добавленных мест. Каждое заведение имеет изображение, адрес и тип, определенный пользователем при создании записи, а так же рейтинг из 5 звезд, как мнение пользователя о данном месте.

Здесь так же мы видим возможность сортировки по дате добавления или имени заведения, а так же 2 стрелочки в верхнем левом углу, при нажатии на них, позволяют просматривать список с начала или с конца. 

![](Screenshots/Главный%20экран.png?raw=true "Главный экран приложения")

Создание новой записи возможно при нажатии на главном экране кнопки с изображением "+". 

![](Screenshots/Новое%20место.png?raw=true "Экран создания новой записи")

На экране добавления записи пользователь указывает название заведения, тип заведения и местоположения заведения, причем адрес можно указать выбрав точку на карте, которая открывается при нажатии на кнопку в правой части поля для заполнения адреса.

![](Screenshots/Выбор%20адреса%20по%20карте.png?raw=true "Выбор адреса на карте")

Так же при нажатии на большую серую область с изоражением условной картинки можно дабавить свое изображение используя ранее сделанный снимок из галереи или сделать фоторгафию.

![](Screenshots/Выбор%20способа%20добавления%20изображения.png?raw=true "Экран добавления нового места")

При сохранении новая запись добавляется в список наших мест. 

![](Screenshots/Добавленное%20место.png?raw=true "Новое заведение в списке")

При нажатии на ячейку в списке открывается экран в котором пользователь может редактировать информацию о заведении или месте. 

![](Screenshots/Экран%20подробной%20информации%20и%20редактирования.png?raw=true "Экран редактирования")

Так же есть возможность при нажатии на кнопку с изображением карт, в нижнем правом углу изображения заведения, посмотреть местоположение заведения на карте и построить маршрут от текущего местоположения пользователя до выбранного места.

![](Screenshots/Отображение%20метки%20на%20карте.png?raw=true "Метка на карте")
![](Screenshots/Построения%20маршрута%20к%20месту.png?raw=true "Построение маршрута")
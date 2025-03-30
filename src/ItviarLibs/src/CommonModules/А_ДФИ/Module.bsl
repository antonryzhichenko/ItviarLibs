//////////////////////////////////////////////////////////////////////////////////
//
//	Модуль Динамического Формирования Интерфейса
//	Начало разработки 29.03.2025 года
//	
//	Автор и разработчик: Рыжиченко Антон Иванович
//	Сайт компании: https://itviar.ru
//	https://github.com/
//	Инфостарт https://infostart.ru/
//	telegram: @
//	
//	Идея создания модуля это собрать воедино накопленный опыт и использовать его в дальнешем
//	В модуле есть заимствования процедур и функций из одноименного проекта Котова Дмитрия Вадимовича
//	
//////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция - Создать поле реквизита объекта
//
// Параметры:
//  Форма		 	- ФормаКлиентскогоПриложения - форма на которой создаются элементы
//  ИмяРеквизита	- Строка - Имя реквизита объекта метаданных
//  Родитель -		- Строка - достаточно указать название элемента формы в качестве родителя
//  				- ФормаКлиентскогоПриложения, ГруппаФормы - форма  или группа формы в качестве родителя
//  				- Массив Из Строка - будет выбран первый найденый по имени в Форма.Элементы
//  ЭлементПосле 	- Строка - достаточно указать название элемента формы, стоящего после добавляемого поля
//  				- ГруппаФормы, ПолеФормы - группа или поле формы
//  				- Массив Из Строка - будет выбран первый найденый по имени в Форма.Элементы
// 
// Возвращаемое значение:
//  ПолеФормы - Созданный элемент на форме
//
Функция СоздатьПолеРеквизитаОбъекта(Форма, ИмяРеквизита, Родитель = Неопределено, ЭлементПосле = Неопределено) Экспорт

	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Форма.Объект.Ссылка));
	МетаданныеРеквизита = МетаданныеОбъекта.Реквизиты.Найти(ИмяРеквизита);

	Поле = СоздатьЭлементФормы(Форма, ИмяРеквизита, Тип("ПолеФормы"), Родитель, ЭлементПосле);
	
	Поле.Вид 			= ВидПоляФормы.ПолеВвода;
	Поле.Заголовок 		= МетаданныеРеквизита.Синоним;
	Поле.ПутьКДанным 	= "Объект." + ИмяРеквизита;
	
	Возврат Поле;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция СоздатьЭлементФормы(Форма, ИмяЭлемента, ТипЭлемента, Родитель = Неопределено, ЭлементПосле = Неопределено) Экспорт
	
	Элементы = Форма.Элементы;
	
	Родитель = ЭлементФормы(Родитель, Форма);
	ЭлементПосле = ЭлементФормы(ЭлементПосле);	
	
	ИмяЭлемента = ОчиститьОтЗапрещенныхСимволов(ИмяЭлемента);
	
	Если ЭлементПосле = Неопределено Тогда
		Элемент = Элементы.Добавить(ИмяЭлемента, ТипЭлемента, Родитель);
	Иначе
		Элемент = Элементы.Вставить(ИмяЭлемента, ТипЭлемента, Родитель, ЭлементПосле);
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

Функция ЭлементФормы(Элемент, ЭлементПоУмолчанию = Неопределено) Экспорт
	
	Если Элемент = Неопределено Тогда
		Возврат ЭлементФормы(ЭлементПоУмолчанию);
	КонецЕсли;
	
	ЭлементФормы = Неопределено;
	
	Если ТипЗнч(Элемент) = Тип("ПолеФормы") ИЛИ ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
		ЭлементФормы = Элемент;
	Иначе
		
		ВызватьИсключение("А_ДФИ.ЭлементФормы тут проблемы");
		
	КонецЕсли;
	
	Возврат ЭлементФормы;
	
КонецФункции

Функция СтрокаРазделитель() 
	
	Возврат ",";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция - Очистить от запрещенных символов
//
// Параметры:
//  ПроверяемаяСтрока		 - Строка - Имя элемента
//  ДопРазрешенныеСимволы	 - Строка - Дополнительно разрешенные символы
// 
// Возвращаемое значение:
//  Строка - Имя элемента очищенное от запрещенных символов
//
Функция ОчиститьОтЗапрещенныхСимволов(ПроверяемаяСтрока, ДопРазрешенныеСимволы = Неопределено)
	
	Если НЕ ЗначениеЗаполнено(ПроверяемаяСтрока) Тогда
		Возврат ПроверяемаяСтрока;
	КонецЕсли;
	
	ОчищеннаяСтрока = "";
	
	РазрешенныеСимволы = "абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ" +
						 "abcdefghijklmnopqrstuvwxyzQWERTYUIOPASDFGHJKLZXCVBNM" + 
						 "0123456789_";
	
	Если ЗначениеЗаполнено(ДопРазрешенныеСимволы) Тогда
		РазрешенныеСимволы = РазрешенныеСимволы + ДопРазрешенныеСимволы;
	КонецЕсли;
	
	Для Сч = 1 по СтрДлина(СокрЛП(ПроверяемаяСтрока)) Цикл
		ТекСимв = Сред(ПроверяемаяСтрока, Сч, 1);
		
		Если СтрНайти(РазрешенныеСимволы, ТекСимв) > 0 Тогда
			ОчищеннаяСтрока = ОчищеннаяСтрока + ТекСимв;
		КонецЕсли;
		
	КонецЦикла;

	Возврат ОчищеннаяСтрока;

КонецФункции

#КонецОбласти
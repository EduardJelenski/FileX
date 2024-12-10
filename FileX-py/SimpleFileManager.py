import os
import json
import zipfile
import re
import xml.etree.ElementTree as ET
import psutil 

class IFileManager:
    def create_file(self, file_name: str):
        raise NotImplementedError
    
    def read_file(self, file_name: str):
        raise NotImplementedError
    
    def delete_file(self, file_name: str):
        raise NotImplementedError
    
    def file_exists(self, file_name: str) -> bool:
        return os.path.exists(file_name)

    def get_file_size(self, file_name: str):
        try:
            file_size = os.path.getsize(file_name)
            print(f"Размер файла {file_name}: {self.format_file_size(file_size)}")
        except OSError as e:
            print(f"Ошибка при получении размера файла: {e}")
    
    @staticmethod
    def format_file_size(size: int) -> str:
        for unit in ['B', 'KB', 'MB', 'GB']:
            if size < 1024:
                return f"{size} {unit}"
            size /= 1024
        return f"{size:.2f} TB"

class JSONFileManager(IFileManager):
    def create_file(self, file_name: str):
        name = input("Введите имя пользователя: ")
        age = input("Введите возраст пользователя: ")

        # Защита от инжектирования, например, убираем небезопасные символы
        name = self.sanitize_input(name)
        age = self.sanitize_input(age)

        print(f"Попытка создать файл: {file_name}") 
    
        try:
            user_data = {"name": name, "age": int(age)}
            with open(file_name, 'w') as file:
                json.dump(user_data, file)
            print(f"JSON файл {file_name} успешно создан.")
        except ValueError:
            print("Возраст должен быть числом.")
        except Exception as e:
            print(f"Ошибка при создании файла: {e}")

    def sanitize_input(self, user_input: str) -> str:
        # Убираем символы, которые могут быть использованы для инжектирования
        return re.sub(r'[^\w\s]', '', user_input)  # Разрешаем только буквы, цифры и пробелы

    def read_file(self, file_name: str):
        try:
            with open(file_name, 'r') as file:
                data = json.load(file)
            print("Содержимое файла:", data)
        except (FileNotFoundError, json.JSONDecodeError):
            print("Ошибка при чтении JSON файла.")
    
    def delete_file(self, file_name: str):
        try:
            os.remove(file_name)
            print(f"JSON файл {file_name} успешно удален.")
        except FileNotFoundError:
            print("Файл не найден.")


class TextFileManager(IFileManager):
    def create_file(self, file_name: str):
        content = input("Введите содержимое файла: ")
        with open(file_name, 'w') as file:
            file.write(content)
        print(f"Текстовый файл {file_name} успешно создан.")
    
    def read_file(self, file_name: str):
        try:
            with open(file_name, 'r') as file:
                print("Содержимое файла:", file.read())
        except FileNotFoundError:
            print("Ошибка: файл не найден.")
    
    def delete_file(self, file_name: str):
        try:
            os.remove(file_name)
            print(f"Текстовый файл {file_name} успешно удален.")
        except FileNotFoundError:
            print("Файл не найден.")

class ZipFileManager(IFileManager):
    def create_file(self, file_name: str):
        source_directory = '/Users/nastasya/Developer/SimpleFileManager/Files'

        with zipfile.ZipFile(file_name, 'w') as zip_file:
            while True:
                file_to_add = input("Введите имя файла для добавления в архив (или 'stop' для завершения): ")
                full_file_path = os.path.join(source_directory, file_to_add)
                if file_to_add.lower() == "stop":
                    break
                if os.path.exists(full_file_path):
                    zip_file.write(full_file_path, arcname=file_to_add) 
                    print(f"Файл {file_to_add} добавлен в архив.")
                else:
                    print("Файл не найден.")

    def read_file(self, file_name: str):
        try:
            with zipfile.ZipFile(file_name, 'r') as zip_file:
                zip_file.printdir()
                extract_to = os.path.splitext(file_name)[0] + "_extracted"  
                os.makedirs(extract_to, exist_ok=True)  
                zip_file.extractall(extract_to)
                print(f"Архив {file_name} успешно извлечен в {extract_to}.")
        except FileNotFoundError:
            print("Ошибка: архив не найден.")
    
    def delete_file(self, file_name: str):
        try:
            os.remove(file_name)
            print(f"Архив {file_name} успешно удален.")
        except FileNotFoundError:
            print("Архив не найден.")

    def unzip_file(self, file_name: str):
        try:
            with zipfile.ZipFile(file_name, 'r') as zip_file:
                extract_to = os.path.splitext(file_name)[0] + "_extracted"
                os.makedirs(extract_to, exist_ok=True)
                zip_file.extractall(extract_to)
                print(f"Архив {file_name} успешно извлечен в папку {extract_to}.")
        except FileNotFoundError:
            print("Ошибка: архив не найден.")

class XMLFileManager(IFileManager):
    def create_file(self, file_name: str):
        root = ET.Element("data")
        user = ET.SubElement(root, "user")
        
        name = input("Введите имя пользователя: ")
        age = input("Введите возраст пользователя: ")
        
        ET.SubElement(user, "name").text = name
        ET.SubElement(user, "age").text = age
        
        tree = ET.ElementTree(root)
        with open(file_name, 'wb') as file:
            tree.write(file)
        print(f"XML файл {file_name} успешно создан.")

    def read_file(self, file_name: str):
        try:
            tree = ET.parse(file_name)
            root = tree.getroot()
            print("Содержимое XML файла:")
            for elem in root.iter():
                print(elem.tag, ":", elem.text)
        except (FileNotFoundError, ET.ParseError):
            print("Ошибка при чтении XML файла.")
    
    def delete_file(self, file_name: str):
        try:
            os.remove(file_name)
            print(f"XML файл {file_name} успешно удален.")
        except FileNotFoundError:
            print("Файл не найден.")

class FileManagerService:
    def __init__(self):
        self.file_path = '/Users/nastasya/Developer/SimpleFileManager/Files'  
        
        os.makedirs(self.file_path, exist_ok=True)

        self.file_managers = {
            ".json": JSONFileManager(),
            ".txt": TextFileManager(),
            ".zip": ZipFileManager(),
            ".xml": XMLFileManager()
        }
    
    def get_file_type(self, file_name: str):
        return os.path.splitext(file_name)[1]
    
    def show_logical_drives(self):
        info = ""
        partitions = psutil.disk_partitions()
    
        for partition in partitions:
            info += f"Имя устройства: {partition.device}\n"
            info += f"Точка монтирования: {partition.mountpoint}\n"
            info += f"Тип файловой системы: {partition.fstype}\n"
        
            try:
                usage = psutil.disk_usage(partition.mountpoint)
                info += f"Размер диска: {usage.total / (1024 ** 3):.2f} GB\n"
                info += f"Свободное место: {usage.free / (1024 ** 3):.2f} GB\n"
                info += f"Используемое место: {usage.used / (1024 ** 3):.2f} GB\n"
                info += f"Процент использования: {usage.percent}%\n"
            except PermissionError:
                info += "Недостаточно прав для получения информации о диске.\n"
        
            info += "-" * 40 + "\n"
        
        print(info)

    
    def execute_command(self, command: str, file_name: str):
        full_path = os.path.join(self.file_path, file_name) 
        file_type = self.get_file_type(file_name)
        manager = self.file_managers.get(file_type)
        
        if manager:
            if command == "create":
                manager.create_file(full_path)  
            elif command == "read":
                manager.read_file(full_path)  
            elif command == "delete":
                manager.delete_file(full_path) 
            elif command == "size":
                manager.get_file_size(full_path)  
            else:
                print("Неизвестная команда.")
        else:
            print("Неподдерживаемый тип файла.")

if __name__ == "__main__":
    file_manager = FileManagerService()
    
    while True:
        print("\nВыберите действие:")
        print("1. Показать логические диски - show drivers")
        print("2. Создать - create 'filename'")
        print("3. Прочитать - read 'filename'")
        print("4. Удалить - delete 'filename'")
        print("5. Размер файла - size 'filename'")
        print("6. Разархивировать файл - unzip 'filename'")
        print("0. Выход")
        
        command = input("Введите команду: ")
        
        if command == "0":
            print("Выход из программы.")
            break
        elif command == "show drivers":
            file_manager.show_logical_drives()
        else:
            parts = command.split()
            if len(parts) == 2:
                file_manager.execute_command(parts[0], parts[1])
            else:
                print("Некорректный ввод.")

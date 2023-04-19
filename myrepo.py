import os, glob

def build_packages():

    #Задаем список нужных пакетов
    packages = ['bash', 'gawk', 'sed']

    # Добавляем репозиторий bullseye 
    os.system('sudo echo "deb-src http://mirror.yandex.ru/debian bullseye main" >> /etc/apt/sources.list')
    os.system('sudo apt-get update --allow-insecure-repositories')

    # Сачиваем исходный код нужных пакетов из репозитория
    for package in packages:
        os.system(f'apt-get --allow-unauthenticated source {package}')

    # Устанавливаем зависимости для сборки каждого пакета
    for package in packages:
        os.system(f'sudo apt-get build-dep {package}')

    # Устанавливаем инструменты для сборки
    os.system('sudo apt-get install build-essential devscripts debhelper dh-autoreconf dh-systemd')

    # Собираем каждый пакет
    for package in packages:
        os.chdir(".")
        package_dir = glob.glob(f"./{package}-*")[0]
        os.chdir(package_dir)
        os.system('dpkg-buildpackage -rfakeroot -b -us -uc -i')
        os.chdir('..')

# Функция сборки собственного составного пакета
def build_my_package():
    # Копируем  .deb файлы в сборочный каталог
    os.makedirs('my-package-1.0/DEBIAN')
    os.system('cp bash*.deb gawk*.deb sed*.deb my-package-1.0/')

    # Пишем control файл для нового пакета
    control = 'Package: my-package-1.0\nVersion: 1.0\nDepends: \nArchitecture: all\nMaintainer: email <erazdoabrov@gmail.com>\nDescription: My package that includes  bash, gawk, and sed\n'
    with open('my-package-1.0/DEBIAN/control', 'w') as f:
        f.write(control)

    # Собираем пакет
    os.system('dpkg-deb --build my-package-1.0')

def main():
    build_packages()
    build_my_package()

if __name__ == "__main__":
    main()

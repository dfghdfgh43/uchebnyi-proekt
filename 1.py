import os

# Получение размера файла (каталога)
def getSize(path):
    try:
        return os.path.getsize(path)
    except OSError:
        totalSize = 0
        
        for dirpath, dirnames, filenames in os.walk(path):
            for f in filenames:
                fp = os.path.join(dirpath, f)
                totalSize += os.path.getsize(fp)
        return totalSize

# Размеры файлов в текущей каталоге
def sizeDirFile(directory, pageSize=10):
    sizes = []
    
    for item in os.listdir(directory):
        itemPath = os.path.join(directory, item)
        size = getSize(itemPath)
        sizes.append((size, itemPath))

    # Сортировка по убыванию
    sizes.sort(reverse=True)

    currentPage = 0
    totalPages = len(sizes) // pageSize + (len(sizes) % pageSize > 0)

    while currentPage < totalPages:
        print(f"{currentPage + 1} из {totalPages}")
        print("------------------")
        print("Размер\tПуть")
        
        for i in range(pageSize):
            index = currentPage * pageSize + i
            
            if index < len(sizes):
                size, itemPath = sizes[index]
                print(f"{size}\t{itemPath}")
            else:
                break

        currentPage += 1
        print("------------------")
        if currentPage < totalPages:
            input("Далее.... Enter жми!")

if __name__ == "__main__":
    currentDirectory = os.getcwd()
    sizeDirFile(currentDirectory)
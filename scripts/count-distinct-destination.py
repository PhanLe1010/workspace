# used to count and sort output of `ss -a -n` by desination IP
file_path = input("absolute path to file: ")
dic = dict()
with open(file_path, "r") as f:
    for line in f:
        tokens = line.split()
        if len(tokens) == 0:
            continue
        destination = tokens[-1]
        tokens = destination.split(':')
        if len(tokens) != 2:
            continue
        dic[tokens[0]] = dic.get(tokens[0], 0) + 1

print("destination-ip\tcount")
for k, v in sorted(dic.items(), key=lambda item: -item[1]):
    print(k + "\t" + str(v))

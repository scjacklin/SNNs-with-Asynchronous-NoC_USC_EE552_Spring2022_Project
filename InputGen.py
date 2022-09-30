import numpy as np


def main():
    print('Hello, World!\n')
    ifsize = 5
    kernelsz = 3
    tsteps = 10

    # build_krnl_thresh(kernelsz, 64, True)
    # ifmaps = build_ifmaps(ifsize, tsteps, True)

    krnl = np.reshape([[14, 5, 8], [4, 8, 7], [10, 9, 10]], (kernelsz, kernelsz))
    Vth = 64

    sparse = True
    if sparse:
        krnl = np.reshape([[0, 5, 0], [0, 0, 7], [10, 0, 0]], (kernelsz, kernelsz))
        Vth = Vth/4

    ifmaps = load_if_matrix(ifsize, sparse)
    SNN_convs(ifmaps, krnl, tsteps, Vth)

    print('krnl:\n' + str(krnl[0][0]) + ' ' + str(krnl[0][1]) + ' ' + str(krnl[0][2]))
    print(str(krnl[1][0]) + ' ' + str(krnl[1][1]) + ' ' + str(krnl[1][2]))
    print(str(krnl[2][0]) + ' ' + str(krnl[2][1]) + ' ' + str(krnl[2][2])+'\n')

    print('\nDone')


def SNN_convs(ifmaps, krnl, tsteps, Vth):
    output_size = ifmaps[0].shape[0] - krnl.shape[0] + 1
    mem_pots = np.zeros((krnl.shape[0], krnl.shape[1]))

    for t in range(0, tsteps):  # iterate over timesteps
        spikes = np.zeros((krnl.shape[0], krnl.shape[1]))
        ifm = ifmaps[t]
        for i in range(0, output_size):  # iterate over output rows
            for j in range(0, output_size):  # iterate over output cols
                block = get_block(i, j, ifm)
                mem_pots[i][j] = mem_pots[i][j] + np.sum(np.multiply(block, krnl))
                if mem_pots[i][j] >= Vth:
                    spikes[i][j] = 1
                    mem_pots[i][j] = mem_pots[i][j] - Vth
        print('\nt = ' + str(t+1) + ' mem_pots after spike subtraction')
        print(mem_pots)
        print('\nt = ' + str(t+1) + ' spikes')
        print(spikes)
    return


def get_block(outx, outy, ifm):
    res = ifm
    if outx == 0:
        res = np.delete(res, 4, 0)
        res = np.delete(res, 3, 0)
    elif outx == 1:
        res = np.delete(res, 4, 0)
        res = np.delete(res, 0, 0)
    else:
        res = np.delete(res, 1, 0)
        res = np.delete(res, 0, 0)

    if outy == 0:
        res = np.delete(res, 4, 1)
        res = np.delete(res, 3, 1)
    elif outy == 1:
        res = np.delete(res, 4, 1)
        res = np.delete(res, 0, 1)
    else:
        res = np.delete(res, 1, 1)
        res = np.delete(res, 0, 1)
    return res


def load_if_matrix(dim, sparse=False):
    iflist = []
    if_matrix = []
    # Using readlines()
    if (sparse):
        file1 = open('sparse_ifmaps.txt', 'r')
    else:
        file1 = open('base_ifmaps.txt', 'r')
    Lines = file1.readlines()
    l = []
    for line in Lines:
        if line.__contains__('*'):
            if_matrix = np.reshape(l, (dim, dim))
            iflist.append(if_matrix)
            l.clear()
        else:
            l.append((int)(line))

    # fencepost solution
    if_matrix = np.reshape(l, (dim, dim))
    iflist.append(if_matrix)
    iflist.append(if_matrix)

    return iflist


def build_krnl_thresh(dim, max, sparse=False):
    print("\nkernels\n")
    krnl = 15 * (np.random.rand(dim, dim))
    sparsefactor = (np.round(np.random.rand(dim, dim) * 0.68))
    print("total_wt_sum = " + str(np.round(np.sum(krnl))))

    if (sparse):
        print('\nSparse version:')  # typically gives 4-12% spikes
        x = np.round(krnl * sparsefactor)
        print(x)
    krnl = np.round(krnl)

    print('\n\nRegular version:')
    print(krnl)

    return krnl


def build_ifmaps(dim, t, sparse=False):
    print("\nif maps\n")
    iflist = []

    for i in range(t):
        ifmap_t = (np.random.rand(dim, dim))

        if (sparse):
            print('\nSparse version:')  # typically gives 4-12% spikes
            print(np.round(ifmap_t * 0.57))
        ifmap_t = np.round(ifmap_t)
        iflist.append(ifmap_t)

        print('\n\nRegular version:')
        print(ifmap_t)
        print()

    return iflist

def filterFilePrintSetup(xdim,ydim, pathIn):
    print("Below this is filters in ")
    return

if __name__ == '__main__':
    main()

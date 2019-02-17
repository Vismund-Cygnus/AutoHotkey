using System;
using System.Runtime.InteropServices;
using System.IO;
using System.IO.MemoryMappedFiles;
using System.Collections.Generic;

namespace MusicBeePlugin
{
    public class SharedMemoryMgr
    {
        private int sizeofLong = Marshal.SizeOf(typeof(long));

        private const ushort DEFAULT_MMF_SIZE = 10240; // 10KB

        private MemoryMappedFile mmf;
        private ushort mmfId = 1;
        // Start, Size
        private SortedDictionary<ushort, ushort> inUse;
        private long freeSpace = DEFAULT_MMF_SIZE;

        // Id, MemoryMappedFile
        private SortedDictionary<ushort, MemoryMappedFile> submmfs;
        private ushort submmfId = 2;

        public SharedMemoryMgr()
        {
            inUse = new SortedDictionary<ushort, ushort>();

            submmfs = new SortedDictionary<ushort, MemoryMappedFile>();

            while (MMFExists("mbipc_mmf_" + mmfId.ToString()))
            {
                if (mmfId >= ushort.MaxValue)
                    throw new Exception("Unable to create MMF.");

                mmfId++;
            }

            mmf = MemoryMappedFile.CreateNew("mbipc_mmf_" + mmfId.ToString(), DEFAULT_MMF_SIZE);
        }

        public IntPtr Alloc(long capacity)
        {
            long cb = capacity + sizeofLong;

            if (cb > freeSpace)
            {
                try
                {
                    ushort id = CreateSubMMF(cb);
                    submmfs[id].CreateViewAccessor().Write(0, capacity);
                    return (new LRUShort(id, 0)).lr;
                }
                catch
                {
                    return IntPtr.Zero;
                }
            }

            ushort position = 0;
            long end = position + cb;

            foreach (var p in inUse)
            {
                if (end < p.Key)
                {
                    inUse.Add(position, (ushort)cb);
                    freeSpace -= cb;
                    mmf.CreateViewAccessor().Write(position, capacity);
                    return (new LRUShort(mmfId, position)).lr;
                }
                else
                {
                    position = (ushort)(p.Key + p.Value);
                    end = position + cb;
                }
            }

            if (end < DEFAULT_MMF_SIZE)
            {
                inUse.Add(position, (ushort)cb);
                freeSpace -= cb;
                mmf.CreateViewAccessor().Write(position, capacity);
                return (new LRUShort(mmfId, position)).lr;
            }
            else
            {
                try
                {
                    ushort id = CreateSubMMF(cb);
                    submmfs[id].CreateViewAccessor().Write(0, capacity);
                    return (new LRUShort(id, 0)).lr;
                }
                catch
                {
                    return IntPtr.Zero;
                }
            }
        }

        public void Free(IntPtr lr)
        {
            LRUShort ls = new LRUShort(lr);

            if (submmfs.ContainsKey(ls.low))
                FreeSubMMF(ls.low);
            else if (ls.low == mmfId && inUse.ContainsKey(ls.high))
            {
                freeSpace += inUse[ls.high];
                inUse.Remove(ls.high);
            }
        }

        public MemoryMappedViewAccessor GetAccessor(IntPtr lr)
        {
            LRUShort ls = new LRUShort(lr);

            if (submmfs.ContainsKey(ls.low))
                return submmfs[ls.low].CreateViewAccessor(sizeofLong, 0);
            else if (ls.low == mmfId && inUse.ContainsKey(ls.high))
                return mmf.CreateViewAccessor(ls.high + sizeofLong, inUse[ls.high] - sizeofLong);
            else
                throw new System.ArgumentException();
        }

        public MemoryMappedViewStream GetStream(IntPtr lr)
        {
            LRUShort ls = new LRUShort(lr);

            if (submmfs.ContainsKey(ls.low))
                return submmfs[ls.low].CreateViewStream(sizeofLong, 0);
            else if (ls.low == mmfId && inUse.ContainsKey(ls.high))
                return mmf.CreateViewStream(ls.high + sizeofLong, inUse[ls.high] - sizeofLong);
            else
                throw new System.ArgumentException();
        }

        public BinaryWriter GetWriter(IntPtr lr)
        {
            LRUShort ls = new LRUShort(lr);

            if (submmfs.ContainsKey(ls.low))
                return new BinaryWriter(submmfs[ls.low].CreateViewStream(sizeofLong, 0));
            else if (ls.low == mmfId && inUse.ContainsKey(ls.high))
                return new BinaryWriter(mmf.CreateViewStream(ls.high + sizeofLong, inUse[ls.high] - sizeofLong));
            else
                throw new System.ArgumentException();
        }

        private ushort CreateSubMMF(long capacity)
        {
            for (int i = 0; submmfId != 0 && MMFExists("mbipc_mmf_" + submmfId.ToString()); i++)
            {
                // Throw exception if no empty slot is found after 1 full cycle
                if (i > ushort.MaxValue)
                    throw new Exception("Unable to create new sub-MMF.");

                submmfId++;
            }

            submmfs.Add(submmfId, MemoryMappedFile.CreateNew("mbipc_mmf_" + submmfId.ToString(), capacity));

            return submmfId;
        }

        private void FreeSubMMF(ushort id)
        {
            submmfs.Remove(id);
        }

        private bool MMFExists(string mapName)
        {
            try
            {
                var f = MemoryMappedFile.OpenExisting(mapName);

                return true;
            }
            catch (System.IO.FileNotFoundException)
            {
                return false;
            }
        }
    }
}

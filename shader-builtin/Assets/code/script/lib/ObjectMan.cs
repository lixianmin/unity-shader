
/********************************************************************
created:	2011-11-01
author:		lixianmin

purpose:	object manager
Copyright (C) - All Rights Reserved
*********************************************************************/
using System;
using System.Collections.Generic;

namespace lib
{
    public class ObjectMan<T> :IDisposable where T : ObjectMan<T>
    {
        public ObjectMan()
        {
            ID	= _kInvalId;
        }

        ~ObjectMan()
        {
            Dispose();
        }

        public void InitId()
        {
            InitId(++_oidGenerator);
        }

        public void InitId(long id)
        {
			Dispose();
            ID				= id;
            _mObjects[id]	= this as T;
        }

        public void Dispose()
        {
            if (ID != _kInvalId)
            {
                _mObjects.Remove(ID);
                ID = _kInvalId;
            }
        }

        public static T GetById(long id)
        {
            T item;
            _mObjects.TryGetValue(id, out item);
            return item;
        }

        public static IEnumerable<T> Items
        {
            get { return _mObjects.Values; }
        }

        public override string ToString()
        {
            return string.Format("Type= {0}, ID= {1}", typeof(T), ID);
        }

		private const long 	_kInvalId 		= -1;
		private static long _oidGenerator	= _kInvalId;
		private static Dictionary<long, T> _mObjects = new Dictionary<long, T>();

		public long 		ID 		{ get; private set; }
		public static int	Count 	{ get { return _mObjects.Count; } }
		public static bool	IsEmpty { get { return _mObjects.Count == 0; }}
	}
}

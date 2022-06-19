
/********************************************************************
created:	2011-10-21
author:		lixianmin

purpose:	least recent used cache
Copyright (C) - All Rights Reserved
 *********************************************************************/
using System;
using System.Collections.Generic;
// using System.Runtime.CompilerServices;

namespace lib
{
	public interface ICheckDisposable: IDisposable
	{
		bool IsDisposable();
	}

	public class LRUCache<TKey, TValue>  where TValue : ICheckDisposable
	{
		public LRUCache(int capacity)
		{
			if(capacity <= 0)
			{
				throw new InvalidOperationException("LRUCache capacity must be positive");
			}

			Capacity	= capacity;
			_lruCache	= new Dictionary<TKey, LinkedListNode<KeyValuePair<TKey, TValue>>>(capacity);
		}

		// if reach Capacity, remove the first disposable node
		private void _EnsureCapacity()
		{
			while(_lruCache.Count > Capacity)
			{
				 var node	= _lruList.Find(item => item.Value.IsDisposable());
				 if(null == node)
				 {
					 break;
				 }

				 var pair	= node.Value;
				 pair.Value.Dispose();
				_lruList.Remove(node);
				_lruCache.Remove(pair.Key);
			}

			// DebugEx.Log("Count={0}", _lruCache.Count.ToString());
		}

		// [MethodImpl(MethodImplOptions.Synchronized)]
        public void Add(TKey key, TValue val)
        {
            LinkedListNode<KeyValuePair<TKey, TValue>> node = null;
            var pair	= new KeyValuePair<TKey, TValue>(key, val);

			// if exists, overwrite it
			if(_lruCache.TryGetValue(key, out node))
			{
				_lruList.Remove(node);
				_lruList.AddLast(node);
				node.Value	= pair;
			}
			else
			{
				_EnsureCapacity();
				// add a new node to Last
				 node	= new LinkedListNode<KeyValuePair<TKey, TValue>>(pair);
				_lruList.AddLast(node);
				_lruCache.Add(key, node);
			}
        }

		// [MethodImpl(MethodImplOptions.Synchronized)]
		public bool Remove(TKey key)
		{
			LinkedListNode<KeyValuePair<TKey, TValue>> node = null;
			if(_lruCache.TryGetValue(key, out node))
			{
				_lruList.Remove(node);
				_lruCache.Remove(key);
				return true;
			}

			return false;
		}

		// [MethodImpl(MethodImplOptions.Synchronized)]
        public bool TryGetValue(TKey key, out TValue val)
        {
            LinkedListNode<KeyValuePair<TKey, TValue>> node = null;
            if (_lruCache.TryGetValue(key, out node))
            {
                _lruList.Remove(node);
                _lruList.AddLast(node);
                val = node.Value.Value;
                return true;
            }

            val = default(TValue);
            return false;
        }

        public TValue Get(TKey key)
        {
            LinkedListNode<KeyValuePair<TKey, TValue>> node = null;
            if (_lruCache.TryGetValue(key, out node))
            {
                _lruList.Remove(node);
                _lruList.AddLast(node);
                return node.Value.Value;
            }

            return default(TValue);
        }

		public TValue SetDefault(TKey key, Func<TValue> creater)
		{
            LinkedListNode<KeyValuePair<TKey, TValue>> node = null;
            if (_lruCache.TryGetValue(key, out node))
            {
                _lruList.Remove(node);
                _lruList.AddLast(node);
                return node.Value.Value;
            }
			else 
			{
				_EnsureCapacity();

				// add a new node to Last
				var val		= creater();
				var pair	= new KeyValuePair<TKey, TValue>(key, val);
				node		= new LinkedListNode<KeyValuePair<TKey, TValue>>(pair);
				_lruList.AddLast(node);
				_lruCache.Add(key, node);
				return val;
			}
		}

		public bool ContainsKey(TKey key)
		{
			LinkedListNode<KeyValuePair<TKey, TValue>> node = null;
            if (_lruCache.TryGetValue(key, out node))
            {
                _lruList.Remove(node);
                _lruList.AddLast(node);
                return true;
            }

			return false;
		}

		public IEnumerable<TKey>	Keys 
		{
			get 
			{
				foreach(var pair in _lruList)
				{
					yield return pair.Key;
				}
			}
		}

		public IEnumerable<TValue>	Values
		{
			get 
			{
				foreach(var pair in _lruList)
				{
					yield return pair.Value;
				}
			}
		}

		public int Count 		{ get { return _lruCache.Count; }}
		public int Capacity		{ get; private set; }

		private readonly Dictionary<TKey, LinkedListNode<KeyValuePair<TKey, TValue>>> _lruCache;
		private readonly LinkedList<KeyValuePair<TKey, TValue>> _lruList = new LinkedList<KeyValuePair<TKey, TValue>>();
	}
}

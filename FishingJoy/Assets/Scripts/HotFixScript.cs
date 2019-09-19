using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;

public class HotFixScript : MonoBehaviour
{

    private LuaEnv luaEnv;
    // Start is called before the first frame update
    void Start()
    {
        luaEnv = new LuaEnv();
        luaEnv.AddLoader(MyLoader);
        luaEnv.DoString("require 'fish'");
    }

    // Update is called once per frame
    void Update()
    {

    }

    private byte[] MyLoader(ref string filePath)
    {
        string absPath = @"/Users/Alex/Desktop/XluaProjects/FishingJoy/XLuascripts/" + filePath + ".lua.txt";
        return System.Text.Encoding.UTF8.GetBytes(File.ReadAllText(absPath));
    }

    private void OnDisable()
    {
        luaEnv.DoString("require 'fishDispose'");
    }

    private void OnDestroy()
    {
        luaEnv.Dispose();
    }
}

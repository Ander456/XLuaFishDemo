﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;
using UnityEngine.Networking;

public class HotFixScript : MonoBehaviour
{

    private LuaEnv luaEnv;

    public static Dictionary<string, GameObject> prefabDict = new Dictionary<string, GameObject>();

    private void Awake()
    {
        luaEnv = new LuaEnv();
        luaEnv.AddLoader(MyLoader);
        luaEnv.DoString("require 'fish'");
    }
    void Start()
    {

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

    [LuaCallCSharp]
    public void LoadResource(string resName, string filePath)
    {
        StartCoroutine(LoadResourceCoroutine(resName, filePath));
    }

    IEnumerator LoadResourceCoroutine(string resName, string filePath)
    {
        UnityWebRequest request = UnityWebRequestAssetBundle.GetAssetBundle(@"http://localhost:8080/AssetBundle/" + filePath);
        yield return request.SendWebRequest();
        AssetBundle ab = (request.downloadHandler as DownloadHandlerAssetBundle).assetBundle;
        GameObject gameObject = ab.LoadAsset<GameObject>(resName);
        prefabDict.Add(resName, gameObject);
    }

    [LuaCallCSharp]
    public static GameObject GetGameObject(string goName)
    {
        return prefabDict[goName];
    }
}

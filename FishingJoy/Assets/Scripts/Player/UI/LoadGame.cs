using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using UnityEngine.Networking;
using System.IO;
public class LoadGame : MonoBehaviour
{

    public Slider processView;

    // Use this for initialization
    void Start()
    {
        LoadGameMethod();

    }

    // Update is called once per frame
    void Update()
    {


    }
    public void LoadGameMethod()
    {
        StartCoroutine(LoadResourceCoroutine());
        StartCoroutine(StartLoading_4(2));
    }

    private IEnumerator StartLoading_4(int scene)
    {
        int displayProgress = 0;
        int toProgress = 0;
        AsyncOperation op = SceneManager.LoadSceneAsync(scene);
        op.allowSceneActivation = false;
        while (op.progress < 0.9f)
        {
            toProgress = (int)op.progress * 100;
            while (displayProgress < toProgress)
            {
                ++displayProgress;
                SetLoadingPercentage(displayProgress);
                yield return new WaitForEndOfFrame();
            }
        }

        toProgress = 100;
        while (displayProgress < toProgress)
        {
            ++displayProgress;
            SetLoadingPercentage(displayProgress);
            yield return new WaitForEndOfFrame();
        }
        op.allowSceneActivation = true;
    }

    IEnumerator LoadResourceCoroutine()
    {
        UnityWebRequest request = UnityWebRequest.Get(@"http://localhost:8080/fish.lua.txt");
        yield return request.SendWebRequest();
        string str = request.downloadHandler.text;
        File.WriteAllText(@"/Users/Alex/Desktop/XluaProjects/FishingJoy/XLuascripts/fish.lua.txt", str);

        UnityWebRequest request2 = UnityWebRequest.Get(@"http://localhost:8080/fishDispose.lua.txt");
        yield return request2.SendWebRequest();
        string str2 = request2.downloadHandler.text;
        File.WriteAllText(@"/Users/Alex/Desktop/XluaProjects/FishingJoy/XLuascripts/fishDispose.lua.txt", str2);
    }

    private void SetLoadingPercentage(float v)
    {
        processView.value = v / 100;
    }


}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
public class StartGame : MonoBehaviour {

    private Button but;

	// Use this for initialization
	void Start () {
        but = GetComponent<Button>();
        but.onClick.AddListener(StartGames);
	}

    private void StartGames()
    {
        SceneManager.LoadScene(1);
    }

	// Update is called once per frame
	void Update () {
		
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// boss攻击玩家产生的震动方法
/// </summary>
public class Shake : MonoBehaviour {


    private float cameraShake = 2;
    public GameObject UI;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        if (Gun.Instance.bossAttack)
        {

            UI.SetActive(true);
            transform.position = new Vector3((Random.Range(0f, cameraShake)) - cameraShake*0.5f, transform.position.y, transform.position.z);
            transform.position = new Vector3(transform.position.x, transform.position.y, (Random.Range(0f, cameraShake)) - cameraShake * 0.5f);
            cameraShake = cameraShake / 1.05f;
            if (cameraShake<0.05f)
            {

                cameraShake= 0;
                UI.SetActive(false);
                Gun.Instance.bossAttack = false;
            }
        }
        else
        {
            cameraShake = 5;
        }
	}
}

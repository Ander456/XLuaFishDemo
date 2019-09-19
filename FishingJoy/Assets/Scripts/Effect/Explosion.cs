using System.Collections;
using System.Collections.Generic;
using UnityEngine;
/// <summary>
/// 爆炸特效
/// </summary>
public class Explosion : MonoBehaviour {

    public float DestoryTime = 0.2f;

	// Use this for initialization
	void Start () {
        Destroy(this.gameObject, DestoryTime);
	}
	
	// Update is called once per frame
	void Update () {
        transform.localScale +=new Vector3(Time.deltaTime*10, Time.deltaTime*10, Time.deltaTime*10) ;
	}
}

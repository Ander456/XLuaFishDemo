using UnityEngine;
using System.Collections;

/// <summary>
/// 产生UI泡泡
/// </summary>
public class CreatePao : MonoBehaviour
{

    public GameObject pao;
    public Transform panel;
    private float timeVal = 6;


    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

        if (timeVal >= 6)
        {
            for (int i = 0; i < 4; i++)
            {
                Invoke("InstPao", 1);
            }
            timeVal = 0;
        }
        else
        {
            timeVal += Time.deltaTime;
        }
    }

    private void InstPao()
    {

        GameObject itemGo = Instantiate(pao, transform.position, Quaternion.Euler(0, 0, Random.Range(-80, 0))) as GameObject;
        itemGo.transform.SetParent(panel);
    }
}

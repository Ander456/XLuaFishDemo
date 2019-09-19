using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
/// <summary>
/// 灼烧
/// </summary>
public class Fire : MonoBehaviour
{

    private Button but;
    private float timeVal = 15;
    private bool canUse = true;
    private float totalTime = 15;

    public Slider cdSlider;
    private int reduceDiamands;

    private void Awake()
    {
        but = transform.GetComponent<Button>();
        but.onClick.AddListener(Attack);

    }

    // Use this for initialization

    void Start()
    {
        reduceDiamands = 10;
    }

    // Update is called once per frame
    void Update()
    {
        if (timeVal >= 15)
        {
            timeVal = 15;
        }
        cdSlider.value = timeVal / totalTime;
        if (timeVal >= 15)
        {

            canUse = true;
            cdSlider.transform.Find("Background").gameObject.SetActive(false);
        }
        else
        {

            timeVal += Time.deltaTime;
        }
    }

    private void Attack()
    {
        if (canUse)
        {
            if (!Gun.Instance.Ice && !Gun.Instance.Fire)
            {

                if (Gun.Instance.diamands <= reduceDiamands)
                {
                    return;
                }

                Gun.Instance.DiamandsChange(-reduceDiamands);
                Gun.Instance.Fire = true;
                canUse = false;
                cdSlider.transform.Find("Background").gameObject.SetActive(true);
                timeVal = 0;
                Invoke("CloseFire", 6);
            }
        }

    }

    //关闭必杀的方法
    private void CloseFire()
    {
        Gun.Instance.Fire = false;
    }


}

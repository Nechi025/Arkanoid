using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Multiball : MonoBehaviour
{
    public Transform player;
    private Vector3 velocity;
    [SerializeField] float speed = 4;

    private void Start()
    {
        velocity.z = -1;
    }

    private void Update()
    {
        Move(velocity);
    }

    void Move(Vector3 direction)
    {
        transform.position += direction.normalized * speed * Time.deltaTime;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            GameManager.Instance.MultiBall(player.position, 2);

            Destroy(this.gameObject);
        }
    }
}

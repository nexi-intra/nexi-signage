import React from 'react'

export default function Page(props: { params: { email: string } }) {
  const email = decodeURIComponent(props.params.email)
  return (
    <div>Display {email}</div>
  )
}
